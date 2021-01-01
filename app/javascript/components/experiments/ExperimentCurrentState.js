import React from "react"
import PropTypes from "prop-types"
import consumer from '../../channels/consumer';
import ExperimentBlockWrap from "./ExperimentBlockWrap";
import { TwoStringWrap } from "./ExperimentFunctions"
import { TestTaskShort } from "./ExperimentFunctions";


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
    let query_content = this.state.query_task_list.map((test_task) => <TestTaskShort key={test_task.id} id={test_task.id} start_time={test_task.start_time}/>);
    let started_content = this.state.current_task_list.map((test_task) => <TestTaskShort key={test_task.id} id={test_task.id} start_time={test_task.start_time}/>);

    if (query_content.length == 0) {
      query_content = <TestTaskShort start_time={'0'}/>;
    }

    if (started_content.length == 0) {
      started_content = <TestTaskShort start_time={this.props.not_started_title}/>;
    }

    return (
        <ExperimentBlockWrap title_class_name={'experiment_current_state'} title={this.props.main_title} spinner={this.state.state == 'read'}>
          <TwoStringWrap title={this.props.query_title}>
            {query_content}
          </TwoStringWrap>
          <TwoStringWrap title={this.props.started_title}>
            {started_content}
          </TwoStringWrap>
        </ExperimentBlockWrap>
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
