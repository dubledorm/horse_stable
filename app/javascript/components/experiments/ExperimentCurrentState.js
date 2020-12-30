import React from "react"
import PropTypes from "prop-types"
import Spinner from "../editable_fields/Spinner";
import consumer from '../../channels/consumer';

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
    this.onWebSocketConnection = this.onWebSocketConnection.bind(this);
    this.onWebSocketReceived = this.onWebSocketReceived.bind(this);
    this.OnWebSocketDisconnected = this.OnWebSocketDisconnected.bind(this);
    this.state = { state: 'read',
                   ws_state: 'disconnected',
                   error_message: '',
                   query_task_list: [],
                   current_task_list: [] };
  }

  onWebSocketConnection() {
    this.setState({ws_state: 'connected'});
    // alert('connected1111-22222');
  }

  onWebSocketReceived(data) {
    if (data.experiment_id == this.props.experiment_id) {
      // Запросить данные
      this.getCurrentState();
    }
  }

  OnWebSocketDisconnected() {
    this.setState({ws_state: 'disconnected'});
    // alert('disconnected-2222222')
  }

  componentDidMount() {
    // Подключиться к каналу
    consumer.subscriptions.create({
      channel: 'ExperimentChannel',
      experiment_id: this.props.experiment_id
    }, {connected: this.onWebSocketConnection,
              disconnected: this.OnWebSocketDisconnected,
              received: data => this.onWebSocketReceived(data)
    })
    // Запросить данные
    this.getCurrentState();
  }

  componentWillUnmount() {
    consumer.disconnect()
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
      <div className={'experiment_current_state'}>
        <h4>
          {this.props.main_title}
        </h4>
        <h3>
          {this.props.query_title}
          {query_content}
        </h3>
        <h3>
          {this.props.started_title}
          {started_content}
        </h3>
      </div>
    );
  }
}


ExperimentCurrentState.propTypes = {
  experiment_id: PropTypes.number,
  user_id: PropTypes.number,
  main_title: PropTypes.string,
  query_title: PropTypes.string,
  started_title: PropTypes.string,
  not_started_title: PropTypes.string,
  url: PropTypes.string
};

export default ExperimentCurrentState
