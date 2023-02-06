import React, { useState }  from 'react';
import Answer from './answer.jsx';

const QuestionForm = () => {
  const [question, setQuestion] = useState('What is 99 bottles about?');
  const [answer, setAnswer] = useState('');
  const [csrf, _] = useState(document.querySelector("meta[name='csrf-token']").getAttribute("content"));

  const handleChange = (e) => {
    setQuestion(e.target.value);
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    fetch("/api/v1/questions", {
      method: "POST",
      mode: "cors",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'X-CSRF-Token': csrf
      },
      body: JSON.stringify({ question: { question: question } })
    }).then(resp => resp.json())
      .then(a => setAnswer(a.answer))
      .catch(error => console.log(error))
  }

  const handleFeelingLucky = (e) => {
    e.preventDefault();
    setAnswer("It's my turn to ask a question...do ya feel lucky punk? Well...? Do ya?");
  }

  return (
    <form onSubmit={e => { handleSubmit(e) }}>
      <textarea 
        name='question' 
        value={question}
        className='rounded-md w-full my-4 p-2 min-h-12'
        onChange={e => handleChange(e)}
      />
      <div className="flex justify-around p-2">
        <input 
          type='submit' 
          className='bg-gray-800 text-white rounded-lg px-4 py-3'
          value='Ask Question' 
        />
        <div className='bg-gray-300 text-gray-900 rounded-lg px-4 py-3' onClick={e => handleFeelingLucky(e) }>
          I'm Feeling Lucky
        </div>
      </div>
      {answer && <Answer answer={answer} />}
    </form>
  )
}

export default QuestionForm;