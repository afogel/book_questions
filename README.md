# Ask My Advisor

## Backstory

This was originally a project I created to apply for a product engineer position. Given that the person I sent my application never responded to the email, I consider this work open to anyone that wants an example of a 100% native ruby implementation to create vector embeddings using ruby libraries using the OpenAI API, including: create an embedding for a question, perform a similarity search on segments of the article to give context to openAI API's to give appropriate context, and return a result. The questions and results are cached in order to reduce calls to the OpenAI API.

Here were the requirements of the task:
Rebuild [askmybook.com](http://askmybook.com) in Rails and React.
Must-dos include:

- Script to format PDF manuscript as local data file with embeddings
- Text box to receive question
- Back-end that:
    - fetches most relevant embeddings using local data file
    - caches answers, otherwise hits OpenAI for answer
- Front-end that displays answer

A good response shows off your ability to:

- Understand existing code
- Read through API docs
- Create a new Rails project
- Install and use React within it
- *Coding!*

Currently, the project relies on a few Python libraries. Find Ruby equivalents or rewrite the code such that they are no longer required (this should be possible by keeping the content and embeddings that index them in one file, instead of across two). 

### Notes

- Please structure your commits so that they're easily understandable
- Automated tests are encouraged but not required
- Explain a couple of the big architectural decisions you've made, and anything you learned/would do differently the next time around

## Overview

A Ruby on Rails and React project that utilizes AI to make an article interrogable. The article "Models of Situated Action" by David Williamson Shaffer, published in 2012, is the focus of this experiment. Ask a question and get an instant answer in real-time.
Installation Requirements

- Ruby on Rails
- React
- Rust
- [Pg_vector](https://github.com/pgvector/pgvector) Postgres extension

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

## Additional Thoughts on the Implementation (reflection on architecture and approach, given the task of building within 6-18 hours)

My implementation initially started much more closely mapped to a ruby translation of what you had built in python, though it evolved as I did more research and discovered new gems/libraries I wanted to use.

For the frontend, I decided to use pure functional React components as they’re simpler for me to reason about, as well as seem to be more paradigmatically modern React. I reached for tailwindCSS as it’s a utility framework I’m familiar with and, for me, makes building out styling much faster.

Overall, the FE is fairly simple, with most of the complexity living in the `QuestionForm` component. Since the FE functionality was relatively simple, I chose to keep the FE as vanilla as possible. This means I did not add additional wrappers around AJAX calls, instead just building the API calls using the native `fetch`.

If I were to extend it, I might add better error handling/showing errors to the end user. My implementation was more focused on getting core functionality deployed rather than having complete error handling, so I currently am only logging errors to the console. Additionally, if I were to spend more time on the FE, I could probably clean up the prompt introducing the project and make the form be a bit more mobile friendly.

On the backend, I leaned heavily on the following gems for NLP functionality: tokenizers, polars-df, ruby-openai, neighbor, pdf-reader. I was most excited by the ability to use `neighbor`, which utilizes pg_vector under the hood to store embeddings. I thought it was really cool that I was able to delegate vector multiplication/operations to the database layer and loved the simplicity of using the `neighbors` gem’s API.

Using polars-df and neighbors, however, did have some tradeoffs.

First, polars-df has a dependency of Rust. That shouldn’t be a huge deal, but when I was thinking about how/where to deploy it did start to complicate things. I started by deploying to fly.io using a standard Dockerfile, thinking that as a hobby project this would be fairly easy/not a big deal to ship on the free level. Introducing Rust as a dependency caused the build to fail somehow, and after a few hours of trying to debug whether it was a problem with the Dockerfile, or something else within fly.io, I gave up on using the service altogether. In all, building the app locally took closer the expected 6-8 hours for building , but finding a hosting solution that could accommodate rust as well as the less commonly supported pg_vector postgres extension was time/labor intensive (which made reaching for Heroku a non-starter, since they’re limited in which postgres extensions they support).

Part of the added time to complete the project stemmed from a relative lack of familiarity with Docker. While I learned a lot about Docker during the deployment process, I didn’t end up using it as part of deploying the final app. Instead, I deployed on a DO droplet and paid for hatchbox to help manage the droplet/take care of some of the boilerplate preparation of the linux box.

On the one hand, a tradeoff of this approach is that deploying it the way I did means the app is not containerized, with all the associated benefits of Dockerizing. I couldn’t figure out how to get that to work in the scope of a smaller project for a job application and didn’t feel like this was the most important aspect of the project. On the other hand, by deploying it to a platform where I could easily ssh in and add underlying dependencies, it enabled me to write the entire NLP and data manipulation logic in Ruby. In effect, it enabled pulling the ML logic into the business logic, minimizing the amount of context switching that might required in order to reason about the domain. Finally, I suspect (though this is only a suspicion) that pushing work with embeddings to the database layer (via pg_vector) rather doing it at the application-logic level probably led to better performance since DBs tend to be better optimized for data manipulation.

Upon further reflection, given that the document I built this against was an article rather than a book, I think that I probably could have built some of the content manipulations without reaching for the memory efficiency of polars dataframes. However, if I wanted to extend this to significantly larger models, leveraging polars so that I could keep a large corpus of data in memory probably I think was probably forward thinking.

If I were to reimplement this project, there are two major backend changes I would want to make. First, I would add a `Document` model that `has_many :pages`. I expect that the `Document` model might contain the title of the document, and it might also `has_one_attached :book_pdf` containing the original source as a pdf.

Secondly, I would also store the contents of each page, and associated token_count, as an attribute on the `Page` model. I expect doing so would simplify some of the business logic that I wrote to map between the data stored in the CSV and the embeddings stored in the `Page` model.

Between the two of these changes, I think the business logic would become both more extensible for the uploading of new documents and would also simpler to reason about. In this imagined implementation, I might have an admin portal wherein I have a form with a direct_upload of the document title and the pdf itself. `After_create`, an ActiveRecord callback could create the associated pages and embeddings, which would eliminate the need for a separate rake task to be run to create embeddings of the document.
