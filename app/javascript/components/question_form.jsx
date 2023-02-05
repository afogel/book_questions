import React from 'react';

const QuestionForm = () => {
  const handleSubmit= (e) => {
    e.preventDefault();
    console.log('submitted, presumably')
  }

  return (
    <form onSubmit={e => { handleSubmit(e) }}>
      <textarea 
        name='question' 
        value='What is 99 Bottles about?'
        className='rounded-md w-full my-4 p-2 min-h-12'
      />
      <div className="flex justify-around p-2">
        <input 
          type='submit' 
          className='bg-gray-800 text-white rounded-lg px-4 py-3'
          value='Ask Question' 
        />
        <input 
          type='submit' 
          className='bg-gray-300 text-gray-900 rounded-lg px-4 py-3'
          value="I'm Feeling Lucky"
        />
      </div>
    </form>
  )
}

export default QuestionForm;