from flask import Flask, url_for
app = Flask(__name__)

@app.route('/')
def api_root():
    return 'Welcome\n'

@app.route('/articles')
def api_articles():
    return 'List of ' + url_for('api_articles') + '\n'

@app.route('/articles/<articleid>')
def api_article(articleid):
    return 'You are reading ' + articleid + '\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0')
