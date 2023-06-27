def insert_text(summary):
    document_content = {
        "requests": [
            {
                "insertText": {
                    "text": summary,
                    "location": {
                        "index": 1,
                    },
                },
            },
        ],
    }
    return document_content


def create_doc(name, date, summary):
    document_content = {
        'title': 'Report -' + name,
    }
    return document_content
