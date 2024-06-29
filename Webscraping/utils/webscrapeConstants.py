import re

HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0'}

def removeNonChar(raw_string: str) -> str:
    """
    :return: String without non-alphanumerics but including letters,
    digits, whitespace, colon, ampersand, parentheses, hash symbol, hyphen, and period.
    """
    return re.sub(r'[^\w\s:&()#.-\\"]', '', raw_string).encode('ascii', 'ignore').decode('utf-8')
