import React from "react"
import PropTypes from "prop-types"
import FieldTitle from "../editable_fields/FieldTitle";
import ExperimentAddEnvironment from "./ExperimentAddEnvironment";
import ExperimentEnvironment from "./ExperimentEnvironment";

class TestEnvironmentsEditForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            experiment_environments: JSON.parse(this.props.experiment_environments),
            edit_mode: false,
            spinner: false,
            error_message: ''
        }
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onToggleSpinner = this.onToggleSpinner.bind(this);
        this.onAddEnvironmentHandler = this.onAddEnvironmentHandler.bind(this);
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onReadSuccess = this.onReadSuccess.bind(this);
        this.onReadError = this.onReadError.bind(this);
    }

    onChangeModeHandler(edit_mode) {
        this.setState({edit_mode: edit_mode});
    }


    onAddEnvironmentHandler(value) {
        // Перезапросить ExperimentEnvironments
        this.onToggleSpinner(true);
        $.ajax({
            type: "GET",
            url: this.props.read_environments_url,
            dataType: "json",
            data: { },
            success: this.onReadSuccess,
            error: this.onReadError
        });
    }

    onReadSuccess(data){
        this.setState({ experiment_environments: data });
        this.onToggleSpinner(false);
    }

    onReadError(error){
        this.onToggleSpinner(false);
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }


    onToggleSpinner(mode) {
        this.setState({spinner: mode});
    }

    render () {
        let content;
        let error_message;
        if (this.state.edit_mode) {
            content = <ExperimentAddEnvironment submit_button_text={this.props.submit_button_text}
                                                cancel_button_text={this.props.cancel_button_text}
                                                field_name={this.props.add_environment_field_name}
                                                field_hint={this.props.add_environment_hint}
                                                resource_class={this.props.experiment_test_environment_class}
                                                start_value=''
                                                environments={this.props.environments}
                                                existed_environments={''}
                                                url={this.props.add_environment_url}
                                                onChangeValue={this.onAddEnvironmentHandler}
                                                onChangeMode={this.onChangeModeHandler}
                                                onToggleSpinner={this.onToggleSpinner}
                                                edit_element_type='drop_down_list' />
        }

        if (this.state.error_message) {
            error_message = <div className="rc-field-error">{this.state.error_message}</div>
        }

        return (
            <div className="rc-test-environments-form">
                <FieldTitle name={this.props.name_title}
                            onChangeMode={this.onChangeModeHandler}
                            read_only={this.props.read_only}
                            spinner={this.state.spinner} />
                {this.state.experiment_environments.map((e_environment) => <ExperimentEnvironment key={e_environment.id}
                                                                                                  environment_name={e_environment.name}
                                                                                                  environment_id={e_environment.id}
                                                                                                  variables={e_environment.environment_variables}
                                                                                                  cancel_button_text={this.props.cancel_button_text}
                                                                                                  submit_button_text={this.props.submit_button_text}
                                                                                                  resource_class={this.props.experiment_test_environment_class}
                                                                                                  update_variables_url={this.props.update_variables_url}/>)}
                {content}
                {error_message}
            </div>);
    }
}
TestEnvironmentsEditForm.propTypes = {
    experiment_environments: PropTypes.string,
    environments: PropTypes.string,
    name_title: PropTypes.string,
    update_variables_url: PropTypes.string,
    experiment_test_environment_class: PropTypes.string,
    add_environment_url: PropTypes.string,
    read_environments_url: PropTypes.string,
    add_environment_field_name: PropTypes.string,
    add_environment_hint: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    edit_button_text: PropTypes.string,
    read_only: PropTypes.bool
};

export default TestEnvironmentsEditForm