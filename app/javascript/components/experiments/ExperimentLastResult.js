import React from "react"
import PropTypes from "prop-types"
import consumer from '../../channels/consumer';
import ExperimentBlockWrap from "./ExperimentBlockWrap";
import { TwoStringWrap } from "./ExperimentFunctions"
import { OneStringValue } from "./ExperimentFunctions"
import { OneStringWrap } from "./ExperimentFunctions"

function ResultKod(props) {
    let class_name = 'col-xs-6 col-md-6 success_test_task'

    if (props.result_kod == 'interrupted') {
        class_name = 'col-xs-6 col-md-6 failed_test_task'
    }
    return  <OneStringWrap title={props.title}>
        <div className={class_name}>
            {props.value}
        </div>
    </OneStringWrap>
}

function ResultValues(props) {
    let content = [];

    for (let key in props.values) {
        content.push( <b key={key}>
            <div className={'col-xs-5 col-md-5 col-xs-offset-1 col-md-offset-1'}>
                {key + ':'}
            </div>
            <div className={'col-xs-6 col-md-6'}>
                {props.values[key]}
            </div>
        </b>)
    }
    return <div className={'row'}>
        <div className={'col-xs-12 col-md-12'}>
            {content}
        </div>
    </div>

}

class ExperimentLastResult extends React.Component {
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
            last_result: { test_task_id: '', start_time: '', result_kod: '', translated_result_kod: '', result_values: {}, error_message: '', duration: '' } };
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
        this.setState({ state: 'listen',
            last_result: { start_time: data.start_time,
                test_task_id: data.id,
                result_kod: data.result_kod,
                translated_result_kod: data.translated_result_kod,
                result_values: data.result_values_json,
                error_message: data.result_message,
                duration: data.duration }});
    }

    onReadError(error){
        this.setState({state: 'listen'});
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }


    render () {
        let error_content ='';

        if (this.state.last_result.error_message.length > 0) {
            error_content =
                <TwoStringWrap title={this.props.message_title}>
                    <div className={'col-xs-11 col-md-11 col-xs-offset-1 col-md-offset-1 failed_test_task'}>
                        {this.state.last_result.error_message}
                    </div>
                </TwoStringWrap>

        }
          return (
            <ExperimentBlockWrap title_class_name={'experiment_last_result'} title={this.props.main_title} spinner={this.state.state == 'read'}>
                <OneStringValue title={this.props.test_task_id_title} value={this.state.last_result.test_task_id}/>
                <OneStringValue title={this.props.start_time_title} value={this.state.last_result.start_time}/>
                <ResultKod title={this.props.result_kod_title} value={this.state.last_result.translated_result_kod} result_kod={this.state.last_result.result_kod}/>
                <TwoStringWrap title={this.props.result_values_title}>
                    <ResultValues values={this.state.last_result.result_values}/>
                </TwoStringWrap>
                {error_content}
            </ExperimentBlockWrap>
        );
    }
}


ExperimentLastResult.propTypes = {
    experiment_id: PropTypes.number,
    user_id: PropTypes.number,
    main_title: PropTypes.string,
    test_task_id_title: PropTypes.string,
    start_time_title: PropTypes.string,
    result_kod_title: PropTypes.string,
    result_values_title: PropTypes.string,
    message_title: PropTypes.string,
    url: PropTypes.string
};

export default ExperimentLastResult
