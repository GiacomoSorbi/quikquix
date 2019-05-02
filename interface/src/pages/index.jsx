import React from "react";
import { Route, Switch } from "react-router-dom";
import Home from "./Home";
import QuizCreator from "./QuizCreator";
import QuizList from "./QuizList";

const Routes = props => (
  <Switch>
    <Route exact path="/" component={Home} />
    <Route exact path="/quiz-creator" component={QuizCreator} />
    <Route exact path="/quizzes" component={QuizList} />
  </Switch>
);

export default Routes;
