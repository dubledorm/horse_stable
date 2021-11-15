import React from "react"
import PropTypes from "prop-types"
import BtnCancel from "../editable_fields/BtnCancel";
import BtnPrimary from "../editable_fields/BtnPrimary";
import VariableEditField from "./VariableEditField";

class SetOfVariablesEditForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = { human_set_name: props.human_set_name,
            variables: this.createArrayOfRows(),
            edit_mode: this.props.edit_mode,
            error_message: ''
        }
        this.onSubmit = this.onSubmit.bind(this);
        this.onSubmitSuccess = this.onSubmitSuccess.bind(this);
        this.onSubmitError = this.onSubmitError.bind(this);
        this.onCancel = this.onCancel.bind(this);
        this.onEdit = this.onEdit.bind(this);
        this.onDeleteVariable = this.onDeleteVariable.bind(this);
        this.onAddVariable = this.onAddVariable.bind(this);
    }

    createArrayOfRows() {
        let arrayOfRows = [];
        let i = 1;
        for (let key_name in this.props.variables) {
            arrayOfRows.push({
                key: i++,
                variable_name: key_name,
                variable_value: this.props.variables[key_name]
            })
        }

        if (arrayOfRows.length == 0) {
            arrayOfRows.push({
                key: 1,
                variable_name: '',
                variable_value: ''
            })
        }
        return arrayOfRows;
    }

    maxRowKew() {
        let result = 0;
        for (let variable of this.state.variables) {
            if (variable['key'] > result) {
                result = variable['key'];
            }
        }
        return result + 1;
    }

    onSubmit(){
        this.props.onToggleSpinner(true);
        $.ajax({
            type: "PUT",
            url: this.props.url,
            dataType: "json",
            data: { ['set_id']: this.props.set_id,
            ['human_set_name']: this.state.human_set_name,
            ['variables']: this.state.variables},
            success: this.onSubmitSuccess,
            error: this.onSubmitError
        });
    }

    onSubmitSuccess(){
        this.setState({ error_message: '' });
    }

    onSubmitError(error){
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
    }

    onEdit(){
        this.setState({ edit_mode: false });
    }

    onCancel(){
        this.setState({ edit_mode: false });
    }

    onDeleteVariable(variable_field_name) {
      alert(variable_field_name);
    }

    onAddVariable() {
        let new_variable = this.state.variables.slice(0);
        new_variable.push({key: this.maxRowKew(), variable_name: '', variable_value: ''});
        this.setState({ variables: new_variable });
    }

    createRowsOfVariables() {
        let result = '';
        result = this.state.variables.map((variable_row) => <div className="form-group" key={variable_row['key']}>
            <VariableEditField base_field_name={'row_' + variable_row['key']}
                               variable_name={variable_row['name']}
                               variable_value={variable_row['value']}
                               on_delete={this.onDeleteVariable}/>
            </div>
        )
        return result;
    }

    render() {
        let context = null;
        if (this.state.edit_mode) {
          context = <div className='rc-form-buttons'>
              {this.createRowsOfVariables()}
              <div className="form-group add-button">
                  <BtnPrimary onClickHandler={this.onAddVariable}>+</BtnPrimary>
              </div>
              <BtnCancel onClickHandler={this.onCancel}>{this.props.cancel_button_text}</BtnCancel>
              <BtnPrimary onClickHandler={this.onSubmit}>{this.props.submit_button_text}</BtnPrimary>
          </div>;
        } else
        {
          context = <div className='rc-form-buttons'>
              <BtnPrimary onClickHandler={this.onEdit}>{this.props.edit_button_text}</BtnPrimary>
          </div>;
        }

        return (
            <div className="rc-block-hidden-form">
                <form onSubmit={this.onSubmit} >
                    {context}
                 </form>
            </div>);
    }
}

SetOfVariablesEditForm.propTypes = {
    human_set_name: PropTypes.string,
    set_id: PropTypes.string,
    variables: PropTypes.object,
    url: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    edit_button_text: PropTypes.string,
    edit_mode: PropTypes.bool
};

export default SetOfVariablesEditForm