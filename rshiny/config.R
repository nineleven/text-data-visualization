BASE_URL = 'https://text-viz.herokuapp.com'
# BASE_URL = 'http://localhost:8000'

GET_AVAILABLE_TEXTS_URL <- paste(BASE_URL, '/api/get_available_texts/', sep='')
GET_TEXT_BY_NAME_URL <- paste(BASE_URL, '/api/get_text/', sep='')
ENCODE_TEXT_URL <- paste(BASE_URL, '/api/encode_text/', sep='')