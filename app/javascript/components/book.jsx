import * as React from "react";
import QuestionForm from "./question_form.jsx";

const Book = () => {
  return (
    <div className="flex flex-col space-y-4">
      <div className="block mx-auto">
      <div class="flex-shrink-0">
          <img class="h-48 w-48 rounded-full" src="https://kagi.com/proxy/th?c=3SgynE8ofVcfX71I7M3hS6GDC2_gG-mWxdmR1ay6nb-Roo8297lQOLrCWn9xF6NOerT8i5xh2mvsb2j0DpPOxhrM8xCyf3BrB8vkZLlgVeVfs4qS1CEnDt0d7fzjLwfN" alt="" />
        </div>
      </div>
      <h1 className="text-4xl block mx-auto">Ask my Advisor</h1>
      <div className="w-1/3 block mx-auto">
        <p className="text-xl text-gray-500 text-wrap ">This is an experiment in using AI to make an article penned by my former advisor, David Williamson Shaffer, interrogable. The article, called "Models of Situated Action", was published in 2012* and introduced <em>Epistemic Frame Theory</em>. Ask a question and AI'll answer it in real-time:</p>
        <p className="text-xs">*DOI: <a href="https://doi.org/10.1017/CBO9781139031127">https://doi.org/10.1017/CBO9781139031127</a></p>
        <QuestionForm />
      </div>
    </div>
  );
}

export default Book;