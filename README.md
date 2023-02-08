# Ask My Advisor

A Ruby on Rails and React project that utilizes AI to make an article interrogable. The article "Models of Situated Action" by David Williamson Shaffer, published in 2012, is the focus of this experiment. Ask a question and get an instant answer in real-time.
Installation Requirements

    Ruby on Rails
    React
    Rust
    [Pg_vector](https://github.com/pgvector/pgvector) Postgres extension

## Installation Instructions

1. Clone the repository to your local machine.
2. Install the required dependencies:

```bash
bundle install
yarn install
```

3. Ensure Rust and pg_vector Postgres extension are installed on your machine.
4. Set up the database:
```bash
rails db:create
rails db:migrate
```
5. Generate your own OpenAI API Key and add that into your credentials file by running:
```bash
EDITOR=[your favorite editor] rails credentials:edit --environment=development
```

Then adding to the file
```yaml
OPENAI_API_KEY: [YOUR KEY HERE]
```
6. Run the rake task that generates the embeddings for the different pages. If you want to use a different file, update the `lib/tasks/pdf_to_pages_embeddings.rake` file.

```bash
rails pdf_to_pages_embeddings
```

7. Start the development server:
```bash
bin/dev
```

Visit http://localhost:3020 in your web browser to access the application.

Enjoy!

Feel free to contribute to the project and make it better. If you face any issues, please report them in the Issues section.
