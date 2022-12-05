import React from "react"
import PropTypes from "prop-types"
import FieldTitle from "../editable_fields/FieldTitle";
import EnvironmentVariable from "./EnvironmentVariable";
import BtnCancel from "../editable_fields/BtnCancel";
import BtnPrimary from "../editable_fields/BtnPrimary";

class ExperimentEnvironment extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            variables: this.props.variables.concat({key: '', value: ''}),
            backup_variables: this.props.variables.concat({key: '', value: ''}),
            spinner: false,
            edit_mode: false,
            error_message: ''
        }
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onChangeVariableValue = this.onChangeVariableValue.bind(this);
        this.onChangeVariableKey = this.onChangeVariableKey.bind(this);
        this.onSubmit = this.onSubmit.bind(this);
        this.onSubmitSuccess = this.onSubmitSuccess.bind(this);
        this.onSubmitError = this.onSubmitError.bind(this);
        this.onCancel = this.onCancel.bind(this);
    }

    onChangeModeHandler(edit_mode) {
        this.setState({edit_mode: edit_mode});
    }


    onChangeVariableValue(row_number, new_value) {
        // Вызывается при изменении строки таблицы. А именно, при потере фокуса
        let new_variables = [];
        let index = 0;
        for (let variable of this.state.variables) {
            if (index == row_number) {
                new_variables.push({key: variable.key, value: new_value});
            } else
                new_variables.push(variable);
            index += 1;
        }

        this.setState({variables: new_variables});
    }

    onChangeVariableKey(row_number, new_key) {
        // Вызывается при изменении строки таблицы. А именно, при потере фокуса
        let new_variables = [];
        let index = 0;
        for (let variable of this.state.variables) {
            if (index == row_number) {
                new_variables.push({key: new_key, value: variable.value});
            } else
                new_variables.push(variable);
            index += 1;
        }

        // Проверяем, что нет последней строчки
        if (new_variables[index - 1].key)
          new_variables.push({key: '', value: ''});
        this.setState({variables: new_variables});
    }

    onSubmit(){
        this.setState({spinner: true});
        let variables = []
        for (let variable of this.state.variables) {
            if (variable.value && variable.key) {
                variables.push(variable);
            }
        };
        $.ajax({
            type: "PUT",
            url: this.props.update_variables_url,
            dataType: "json",
            data: { [this.props.resource_class]: { id: this.props.environment_id,
                environment_variables: variables}},
            success: this.onSubmitSuccess,
            error: this.onSubmitError
        });
    }

    onSubmitSuccess(){
        this.setState({spinner: false});
        this.setState({error_message: ''});
        this.setState({backup_variables: this.state.variables.slice()});
        this.onChangeModeHandler(false);
    }

    onSubmitError(error){
        this.setState({spinner: false});
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }

    onCancel(){
        this.setState({variables: this.state.backup_variables.slice()});
        this.onChangeModeHandler(false);
    }

    render() {
        let content = [];
        let buttonsContent = '';
        let index = 100;
        let error_message = '';

        if (this.state.error_message) {
            error_message = <div className="rc-field-error">{this.state.error_message}</div>
        }

        for (let variable of this.state.variables) {
            content.push(
                <EnvironmentVariable key={index} row_number={index-100}
                                     key_name={variable.key || ''}
                                     value={variable.value || ''}
                                     edit_mode={this.state.edit_mode}
                                     onChangeValue={this.onChangeVariableValue}
                                     onChangeKey={this.onChangeVariableKey}/>
            )
            index += 1;
        }

        if (this.state.edit_mode) {
            buttonsContent =
                    <div className='rc-form-buttons' key={2}>
                        <BtnCancel onClickHandler={this.onCancel}>{this.props.cancel_button_text}</BtnCancel>
                        <BtnPrimary onClickHandler={this.onSubmit}>{this.props.submit_button_text}</BtnPrimary>
                    </div>
        }
        return (
            <React.Fragment>
                <FieldTitle name={this.props.environment_name}
                            onChangeMode={this.onChangeModeHandler}
                            read_only={false}
                            spinner={this.state.spinner} />
                <table>
                    <thead>
                      <tr>
                          <th>Ключ</th>
                          <th>Значение</th>
                      </tr>
                    </thead>
                    <tbody>
                      {content}
                    </tbody>
                </table>
                {error_message}
                {buttonsContent}
            </React.Fragment>);
    }
}

ExperimentEnvironment.propTypes = {
    environment_name: PropTypes.string,
    environment_id: PropTypes.number,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    variables: PropTypes.array,
    resource_class: PropTypes.string,
    update_variables_url: PropTypes.string
};


export default ExperimentEnvironment