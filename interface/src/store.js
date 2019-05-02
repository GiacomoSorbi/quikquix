import { createStore, applyMiddleware } from "redux";
import { combineReducers } from "redux";
import { quizCreatorReducer } from "./reducers";
import thunk from "redux-thunk";
import logger from "redux-logger";

export const rootReducer = combineReducers({ quizCreatorReducer });

export const store = createStore(rootReducer, applyMiddleware(thunk, logger));

export default store;
