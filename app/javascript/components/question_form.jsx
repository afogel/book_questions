import React, { useState }  from 'react';
import Answer from './answer.jsx';
import Question from './question.jsx'

const QuestionForm = () => {
  const [question, setQuestion] = useState('What is the main claim of this article?');
  const [askedQuestion, setAskedQuestion] = useState(null);
  const [loading, setLoading] = useState(false);
  const [answer, setAnswer] = useState('');
  const [csrf, _] = useState(document.querySelector("meta[name='csrf-token']").getAttribute("content"));

  const handleChange = (e) => {
    setQuestion(e.target.value);
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    const correctlyStructuredQuestion = question.slice(-1) === "?" ? question : `${question}?`
    fetch("/api/v1/questions", {
      method: "POST",
      mode: "cors",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'X-CSRF-Token': csrf
      },
      body: JSON.stringify({ question: { question: correctlyStructuredQuestion } })
    }).then(resp => resp.json())
      .then(a => {
        setLoading(false)
        setAskedQuestion(question)
        setAnswer(a.answer)
      })
      .catch(error => console.log(error))
  }

  const handleFeelingLucky = (e) => {
    e.preventDefault();
    setLoading(true);
    fetch("/api/v1/questions/1", {
      method: "GET",
      mode: "cors",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'X-CSRF-Token': csrf
      }
    }).then(resp => resp.json())
    .then(a => {
      setLoading(false)
      setAskedQuestion(a.question)
      setAnswer(a.answer)
    })
    .catch(error => console.log(error))
  }

  return (
    <form onSubmit={e => { handleSubmit(e) }}>
      <textarea 
        name='question' 
        placeholder={question}
        className='rounded-md w-full my-4 p-2 min-h-12'
        required={true}
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
      {askedQuestion && !loading && <Question question={askedQuestion} />}
      {answer && !loading && <Answer answer={answer} />}
      {loading && <div className='text-center'>The AI is "thinking"...</div>}
    </form>
  )
}

export default QuestionForm;