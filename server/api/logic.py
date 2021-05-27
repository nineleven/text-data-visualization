alphabeth = 'abcdefghijklmnopqrstuvwxyz'
split_symbols = '.,?!:;-()'


def is_split_character(c):
    '''
    Checks whether the given character
    splits the words, that are to the left and to the right of it.

    Parameters
    ----------
    c : str
        Character
    Returns
    -------
    bool
        Wherether the character is a split character
    '''
    
    if c.isspace():
        return True
    if c in split_symbols:
        return True
    return False
        
def skip_splits(text, i):
    '''
    Does i+=1, until the split character is met

    Parameters
    ----------
    text : str
        Text
    i : int
        Index to start from
    Returns
    -------
    int
        index at which a split character was met
    '''
    
    while i < len(text) and is_split_character(text[i]):
        i += 1
    return i

def extract_word(text, i):
    '''
    Extracts a piece of text from i, to the index
    of the first met split character

    Parameters
    ----------
    text: str
        Text
    i : int
        Starting index
    Returns
    -------
    Tuple[int, str]
        Pair of the first index after the extracted word and the word itself
    '''
    i = skip_splits(text, i)
    
    word_start = i
    
    while i < len(text) and not is_split_character(text[i]):
        i += 1
        
    return i, text[word_start: i]

def get_words(text):
    '''
    Returns words, presented in text

    Parameters
    ----------
    text : str
        Text
    Returns
    -------
    Generator[str, None, None]
        Words
    '''
    i = 0
    
    while True:
        i, word = extract_word(text, i)
        
        if not word:
            break
        
        yield word.lower()
            
def encode_word(word):
    '''
    Encodes a word as a 1x26 vector v, where v[i] is the number
    of occurences of the i'th letter of the alphabeth in the given word

    Parameters
    ----------
    word : str
        Word
    Returns
    -------
    List[int]
        Encoded word
    '''
    code = [0] * len(alphabeth)
    
    for c in word:
        try:
            idx = alphabeth.index(c.lower())
        except ValueError:
            # unknown symbol
            continue
        code[idx] += 1
        
    return code
            
def encode_text(text):
    '''
    Encodes each word of the given text
    and returns the words and the codes

    Parameters
    ----------
    text : str
        Text
    Returns
    -------
    List[str]
        Words
    List[List[int]]
        Codes
    '''
    words = []
    codes = []

    for word in get_words(text):
        code = encode_word(word)
        words.append(word)
        codes.append(code)
        
    return words, codes

