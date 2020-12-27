import React from "react"
import PropTypes from "prop-types"
import Spinner from "../editable_fields/Spinner";

function TestTaskShort(props) {
  return <div className={'row'}>
           <div className={'col-xs-6 col-md-6'}></div>
           <div className={'col-xs-6 col-md-6'}>
             {props.start_time}
           </div>
  </div>
}

class ExperimentCurrentState extends React.Component {
  constructor(props) {
    super(props);
    this.onReadSuccess = this.onReadSuccess.bind(this);
    this.onReadError = this.onReadError.bind(this);
    this.state = { state: 'read',
                   error_message: '',
                   query_task_list: [],
                   current_task_list: [] };
  }

  componentDidMount() {
    // Запросить данные
    this.getCurrentState();
  }

  getCurrentState() {
    this.setState({state: 'read'});
    $.ajax({
      type: "GET",
      url: this.props.url,
      dataType: "json",
      data: { id: this.props.experiment_id, user_id: this.props.user_id },
      success: this.onReadSuccess,
      error: this.onReadError
    });
  }

  onReadSuccess(data){
    this.setState({ state: 'listen', query_task_list: data.query_tasks, current_task_list: data.started_tasks});
  }

  onReadError(error){
    this.setState({state: 'listen'});
    let error_message = error.responseText || error.statusText;
    console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
    this.setState({ error_message: error_message });
  }


  render () {
    let query_content = '';
    let started_content = '';

    if (this.state.state == 'read') {
      query_content = <Spinner />;
      started_content = <Spinner />;
    }
    else {
      query_content = this.state.query_task_list.map((test_task) => <TestTaskShort key={test_task.id} start_time={test_task.start_time}/>);
      started_content = this.state.current_task_list.map((test_task) => <TestTaskShort key={test_task.id} start_time={test_task.start_time}/>);
      if (started_content.length == 0) {
        started_content = <TestTaskShort start_time={this.props.not_started_title}/>;
      }
    }

    return (
      <React.Fragment>
        <h3>
          {this.props.query_title}
          {query_content}
        </h3>
        <h3>
          {this.props.started_title}
          {started_content}
        </h3>
      </React.Fragment>
    );
  }
}


ExperimentCurrentState.propTypes = {
  experiment_id: PropTypes.number,
  user_id: PropTypes.number,
  query_title: PropTypes.string,
  started_title: PropTypes.string,
  not_started_title: PropTypes.string,
  url: PropTypes.string
};

export default ExperimentCurrentState
