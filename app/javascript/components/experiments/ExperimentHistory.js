import React from "react"
import PropTypes from "prop-types"
import consumer from '../../channels/consumer';
import ExperimentBlockWrap from "./ExperimentBlockWrap";
import {TestTask, TwoStringWrap} from "./ExperimentFunctions"

class ExperimentHistory extends React.Component {
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
            history_list: [] };
    }

    onWebSocketConnection() {
        this.setState({ws_state: 'connected'});
    }

    onWebSocketReceived(data) {
        if (data.experiment_id == this.props.experiment_id) {
            // Запросить данные
            this.getLastResult();
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
        this.getLastResult();
    }

    componentWillUnmount() {
        consumer.disconnect()
    }

    getLastResult() {
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
        this.setState({ state: 'listen', history_list: data.history_list });
    }

    onReadError(error){
        this.setState({state: 'listen'});
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }


    render () {
        let content = this.state.history_list.map((test_task) => <TestTask key={test_task.id} test_task={test_task}/>);;
        return (
            <ExperimentBlockWrap title_class_name={'experiment_history'} title={this.props.main_title} spinner={this.state.state == 'read'}>
                {content}
            </ExperimentBlockWrap>
        );
    }
}


ExperimentHistory.propTypes = {
    experiment_id: PropTypes.number,
    user_id: PropTypes.number,
    main_title: PropTypes.string,
    url: PropTypes.string
};

export default ExperimentHistory
