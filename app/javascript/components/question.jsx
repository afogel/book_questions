import React from "react";

const Question = ({ question }) => {
  return (
    <div className='p-2'>
      <p className='text-gray-400 text-sm'>The question being asked is:</p>
      <p className='text-gray-900 text-sm'>{question}</p>
    </div>
  )
}

export default Question;