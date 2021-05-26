alphabeth = 'abcdefghijklmnopqrstuvwxyz'
split_symbols = '.,?!:;-()'


def is_split_character(c):
    if c.isspace():
        return True
    if c in split_symbols:
        return True
    return False
        
def skip_splits(text, i):
    while i < len(text) and is_split_character(text[i]):
        i += 1
    return i

def extract_word(text, i):
    i = skip_splits(text, i)
    
    word_start = i
    
    while i < len(text) and not is_split_character(text[i]):
        i += 1
        
    return i, text[word_start: i]

def get_words(text):
    i = 0
    
    while True:
        i, word = extract_word(text, i)
        
        if not word:
            break
        
        yield word.lower()
            
def encode_word(word):
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
    words = []
    codes = []

    for word in get_words(text):
        code = encode_word(word)
        words.append(word)
        codes.append(code)
        
    return words, codes

def plot_words_repr(words, codes_2d, ax, **kwargs):
    for code_2d, word in zip(codes_2d, words):
        ax.scatter(*code_2d, **kwargs)
        ax.text(*code_2d, word, size=8)
