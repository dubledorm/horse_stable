import React from "react"
import PropTypes from "prop-types"
import consumer from '../../channels/consumer';

class ExperimentOperation extends React.Component {
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
            last_result: { test_task_id: '',
                result_kod: '',
                operation_id: null,
                experiment_case_id: ''
        } };
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
        if (this.state.state.experiment_case_id != null) {
            if (this.state.state.experiment_case_id != data.experiment_case_id) {
                $('#experiment_case_row_' + this.state.state.experiment_case_id).removeClass('failed_experiment_case');
            }
        }

        this.setState({ state: 'listen',
            last_result: {test_task_id: data.id,
                result_kod: data.result_kod,
                operation_id: data.operation_id,
                experiment_case_id: data.experiment_case_id }});
        if (data.experiment_case_id != null) {
            $('#experiment_case_row_' + data.experiment_case_id).addClass('failed_experiment_case');
        }
    }

    onReadError(error){
        this.setState({state: 'listen'});
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }


    render () {
        return (
            <React.Fragment></React.Fragment>
        );
    }
}


ExperimentOperation.propTypes = {
    experiment_id: PropTypes.number,
    user_id: PropTypes.number,
    url: PropTypes.string
};

export default ExperimentOperation
