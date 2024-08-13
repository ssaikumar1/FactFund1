import React from 'react';

const ProgressBar = ({ progress }) => {
  const containerStyles = {
    height: '20px',
    width: '100%',
    backgroundColor: '#e0e0df',
    borderRadius: '50px',
    margin: '50px 0'
  };

  const fillerStyles = {
    height: '100%',
    width: `${progress}%`,
    backgroundColor: '#007bff',
    borderRadius: 'inherit',
    textAlign: 'right',
    transition: 'width 0.5s ease-in-out'
  };

  const labelStyles = {
    padding: '5px',
    color: 'white',
    fontWeight: 'bold'
  };

  return (
    <div style={containerStyles}>
      <div style={fillerStyles}>
        <span style={labelStyles}>{`${progress}%`}</span>
      </div>
    </div>
  );
};

export default ProgressBar;
