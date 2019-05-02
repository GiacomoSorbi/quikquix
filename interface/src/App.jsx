import React from "react";
import "./App.css";
import { Link } from "react-router-dom";

class App extends React.Component {
  render() {
    return (
      <div className="app">
        <header className="app-menu">
          <Link to="/">Home</Link>
          <Link to="/quizzes">Quizzes</Link>
          <Link to="/quiz-creator">Quiz Creator</Link>
        </header>
        {this.props.children}
      </div>
    );
  }
}

export default App;
