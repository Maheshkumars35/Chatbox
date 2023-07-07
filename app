import React, { useState, useEffect } from 'react';

function App() {
  const [comments, setComments] = useState([]);
  const [newComment, setNewComment] = useState('');

  useEffect(() => {
    const storedComments = localStorage.getItem('comments');
    if (storedComments) {
      setComments(JSON.parse(storedComments));
    }
  }, []);

  useEffect(() => {
    localStorage.setItem('comments', JSON.stringify(comments));
  }, [comments]);

  const handleAddComment = () => {
    if (newComment !== '') {
      const timestamp = new Date().toLocaleString(); // Get current timestamp
      const newComments = [...comments, { text: newComment, timestamp, replies: [] }];
      setComments(newComments);
      setNewComment('');
    }
  };

  const handleDeleteComment = (commentIndex) => {
    const updatedComments = [...comments];
    updatedComments.splice(commentIndex, 1);
    setComments(updatedComments);
  };

  const handleAddReply = (commentIndex) => {
    const reply = prompt('Enter your reply:');
    if (reply !== '') {
      const timestamp = new Date().toLocaleString(); // Get current timestamp
      const updatedComments = [...comments];
      updatedComments[commentIndex].replies.push({ text: reply, timestamp, replies: [] });
      setComments(updatedComments);
    }
  };

  const handleDeleteReply = (commentIndex, replyIndex) => {
    const updatedComments = [...comments];
    updatedComments[commentIndex].replies.splice(replyIndex, 1);
    setComments(updatedComments);
  };

  const replyButtonStyle = {
    backgroundColor: 'white',
    color: 'blue',
    border: '1px solid blue',
    cursor: 'pointer',
    marginRight: '8px',
  };

  const deleteButtonStyle = {
    backgroundColor: 'white',
    color: 'red',
    border: '1px solid red',
    cursor: 'pointer',
  };

  const renderReplies = (replies, commentIndex) => {
    return (
      <div style={{ marginLeft: '20px' }}>
        {replies.map((reply, replyIndex) => (
          <div key={replyIndex}>
            <p>{reply.text}</p>
            <p style={{ fontSize: '6px' }}>{reply.timestamp}</p> {/* Display the timestamp */}
            <button style={deleteButtonStyle} onClick={() => handleDeleteReply(commentIndex, replyIndex)}>
              Delete
            </button>
            <button style={replyButtonStyle} onClick={() => handleAddReply(commentIndex)}>
              Reply
            </button>
            {renderReplies(reply.replies, commentIndex)}
          </div>
        ))}
      </div>
    );
  };

  return (
    <div>
      <h2>Comment Widget</h2>
      <div>
        <input
          type="text"
          value={newComment}
          onChange={(e) => setNewComment(e.target.value)}
        />
        <button onClick={handleAddComment}>Add Comment</button>
      </div>
      {comments.map((comment, commentIndex) => (
        <div key={commentIndex}>
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <div>
              <p>{comment.text}</p>
              <p style={{ fontSize: '6px' }}>{comment.timestamp}</p> {/* Display the timestamp */}
            </div>
            <div>
              <button style={deleteButtonStyle} onClick={() => handleDeleteComment(commentIndex)}>
                Delete
              </button>
              <button style={replyButtonStyle} onClick={() => handleAddReply(commentIndex)}>
                Reply
              </button>
            </div>
          </div>
          {renderReplies(comment.replies, commentIndex)}
        </div>
      ))}
    </div>
  );
}

export default App;
