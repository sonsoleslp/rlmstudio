#' Prompt Language Model Function
#'
#' This function sends a prompt to a specified language model API endpoint and returns the generated text.
#'
#' @param prompt A string containing the input text prompt to send to the language model.
#' @param endpoint A string specifying the URL of the language model API endpoint. Default is "http://localhost:1234/v1/completions".
#' @param api_key A string containing the API key for authorization. Default is "lm-studio".
#' @param verbose A logical value indicating whether to return the full response content (TRUE) or just the generated text (FALSE). Default is FALSE.
#' @param ... Additional arguments passed to the LM studio API. See https://lmstudio.ai/docs/local-server
#'
#' @return If \code{verbose} is TRUE, returns a list containing the full response content from the API. If \code{verbose} is FALSE, returns a string of the generated response
#' @examples
#' \dontrun{
#' # Don't forget to have your LM server running!
#' # Basic example
#' prompt_lm("Once upon a time", max_tokens = 50)
#'
#' # Example with verbose output
#' prompt_lm("What is the capital of France?", verbose = TRUE)
#'
#' # Example using the function within a mutate function
#' library(dplyr)
#' df <- data.frame(text_prompts = c("Tell me a joke", "Explain the theory of relativity"))
#' df <- df %>% rowwise %>%
#'   mutate(generated_text = prompt_lm(x))
#' }
#'
#' @export
#' @importFrom httr add_headers POST content status_code
#' @importFrom jsonlite toJSON
prompt_lm <- function(prompt, endpoint = "http://localhost:1234/v1/completions",
                      api_key = "lm-studio", verbose = F, ...) {
  # Define the API endpoint and your API key
  api_url <- endpoint
  api_key <- api_key

  # Set up the request headers including the authorization
  headers <- httr::add_headers(
    `Content-Type` = "application/json",
    `Authorization` = paste("Bearer", api_key)
  )

  # Define the body of the request
  body <- list(
    prompt = prompt,
    ...
  )

  # Make the POST request
  response <- httr::POST(
    url = api_url,
    body = jsonlite::toJSON(body),
    encode = "json",
    headers
  )

  # Check for successful request
  if (httr::status_code(response) == 200) {
    # Parse the JSON response
    response_content <- httr::content(response, as = "parsed")
    if (verbose) {
      return(response_content)
    } else {
      return(response_content$choices[[1]]$text)
    }

  } else {
    stop("API request failed with status code: ", httr::status_code(response))
  }
}
