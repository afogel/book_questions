import React from "react";

const Answer = ({ answer }) => {
  return (
    <div className='p-2'>
      <p className='text-gray-400 text-sm'>AI's answer:</p>
      <p className='text-gray-900 text-sm'>{answer}</p>
    </div>
  )
}

export default Answer;