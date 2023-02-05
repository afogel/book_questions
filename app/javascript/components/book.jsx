import * as React from "react";


const Book = () => {
  return (
    <div className="flex flex-col space-y-4">
      <div className="block mx-auto">Image placeholder</div>
      <h1 className="text-4xl block mx-auto">Ask my book</h1>
      <div className="w-1/2 block mx-auto">
        <p className="text-xl text-gray-400 text-wrap ">This is an experiment in using AI to make a book's content more accessible. Ask a question and AI'll answer it in real-time:</p>
        <input type="textarea" className="rounded-md" />
      </div>

    </div>
  );
}

export default Book;