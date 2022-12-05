import React from "react"
import PropTypes from "prop-types"
import EditForm from "../editable_fields/EditForm";
import BtnPrimary from "../editable_fields/BtnPrimary";

class ExperimentAddEnvironment extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            spinner: false,
            add_environment: false
        }
        this.onAddEnvironment = this.onAddEnvironment.bind(this);
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onChangeValueHandler = this.onChangeValueHandler.bind(this);
    }

    onAddEnvironment() {
        this.setState({add_environment: true});
    }

    onChangeModeHandler(edit_mode) {
        this.setState({add_environment: edit_mode});
        this.props.onChangeMode(false);
    }

    onChangeValueHandler(value) {
        this.props.onChangeValue(value);
    }

    render() {
        let context;
        if (this.state.add_environment) {
                context = <EditForm submit_button_text={this.props.submit_button_text}
                                    cancel_button_text={this.props.cancel_button_text}
                                    field_name={this.props.field_name}
                                    field_hint={this.props.field_hint}
                                    resource_class={this.props.resource_class}
                                    start_value=''
                                    values={this.props.environments}
                                    url={this.props.url}
                                    onChangeValue={this.onChangeValueHandler}
                                    onChangeMode={this.onChangeModeHandler}
                                    onToggleSpinner={this.props.onToggleSpinner}
                                    edit_element_type='drop_down_list'
                                    request_type='POST' />;
        } else {
            context =
                <div className="rc-test-environments-form-content">
                    <BtnPrimary onClickHandler={this.onAddEnvironment}>+</BtnPrimary>
                </div>
        }
        return (
            <React.Fragment>
                {context}
            </React.Fragment>);
    }
}

ExperimentAddEnvironment.propTypes = {
    environments: PropTypes.string,
    existed_environments: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    field_name: PropTypes.string,
    field_hint: PropTypes.string,
    resource_class: PropTypes.string,
    url: PropTypes.string,
    onChangeValue: PropTypes.func,
    onChangeMode: PropTypes.func,
    onToggleSpinner: PropTypes.func
};


export default ExperimentAddEnvironment