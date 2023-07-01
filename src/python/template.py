def get_insert_text_template(summary):
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


def get_create_doc_template(name):
    document_content = {
        'title': name,
    }
    return document_content
