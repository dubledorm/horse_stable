import React from "react"
import PropTypes from "prop-types"
import EditForm from "../editable_fields/EditForm";
import BtnPrimary from "../editable_fields/BtnPrimary";

class ExperimentAddEnvironment extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            spinner: false
        }
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onChangeValueHandler = this.onChangeValueHandler.bind(this);
    }


    onChangeModeHandler() {
        this.props.onChangeMode(false);
    }

    onChangeValueHandler(value) {
        this.props.onChangeValue(value);
    }

    render() {
        return (
            <React.Fragment>
                <EditForm submit_button_text={this.props.submit_button_text}
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
                          request_type='POST' />
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