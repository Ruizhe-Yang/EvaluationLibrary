def example(title, aim, mechanism, expected, watch, change, limit):
    """Keep a Chinese explanation paired with its English translation."""
    for value in (title, aim, mechanism, expected, change, limit):
        if not isinstance(value, tuple) or len(value) != 2 or not all(value):
            raise ValueError('Every teaching field requires Chinese and English')
    if not watch:
        raise ValueError('Every example requires observable variables')
    return dict(title=title, aim=aim, mechanism=mechanism, expected=expected,
                watch=watch, change=change, limit=limit)
