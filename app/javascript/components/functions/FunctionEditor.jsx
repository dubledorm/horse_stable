import React from "react"
import PropTypes from "prop-types"
import FieldTitle from "../editable_fields/FieldTitle";
import FunctionFields from "./FunctionFields";
import BtnCancel from "../editable_fields/BtnCancel";
import BtnPrimary from "../editable_fields/BtnPrimary";


class DropDownField extends React.Component {
  constructor(props) {
      super(props);
      this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
      this.props.onChangeFunction(event.target.value);
  }

  render() {
      let listOptions = '';

      if (this.props.values != null) {
          listOptions = JSON.parse(this.props.values).map((item) => <option key={item[1]} value={item[1]}>{item[0]}</option>);
      }
      return(<select name={this.props.field_name}
                     className="form-control"
                     value={this.props.function_name}
                     onChange={this.handleChange}>
          {listOptions}
      </select>)
  }
}

class FunctionEditor extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onChangeFunctionHandler = this.onChangeFunctionHandler.bind(this);
        this.onReadSuccess = this.onReadSuccess.bind(this);
        this.onReadError = this.onReadError.bind(this);
        this.onToggleSpinner = this.onToggleSpinner.bind(this);
        this.onCancel = this.onCancel.bind(this);
        this.onSubmit = this.onSubmit.bind(this);
        this.state = {
            function_name: props.start_value,
            function_attributes: JSON.parse(props.start_value_attributes),
            spinner: false,
            edit_mode: false,
            read_only: 'read_only' in props ? props.read_only : false,
            error_message: '',
            fields_description: {},
            current_values: {}
        }
    }

    componentDidMount() {
        if (this.props.start_value !== undefined && this.props.start_value !== null && this.props.start_value !== '') {
            this.onChangeFunctionHandler(this.props.start_value);
        }
    }


    onChangeFunctionHandler(function_name) {
        this.setState({function_name: function_name});
        // Запрос за параметрами функции
        this.onToggleSpinner(true);
        $.ajax({
            type: "GET",
            url: this.props.url_for_read_parameters + function_name,
            dataType: "json",
            data: {},
            success: this.onReadSuccess,
            error: this.onReadError
        });
    }

    onReadSuccess(data){
        // alert(data.attributes["attribute_name"]);
        this.setState({ error_message: '' });
        // Запоминаем список полей
        this.setState({fields_description: data });

        this.onToggleSpinner(false);
    }

    onReadError(error){
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
        this.onToggleSpinner(false);
    }


    onChangeModeHandler(edit_mode) {
        this.setState({edit_mode: edit_mode});
    }

    onToggleSpinner(mode) {
        this.setState({spinner: mode});
    }

    onCancel(){
        this.setState({function_name: this.props.start_value});
        this.onChangeModeHandler(false);
        this.componentDidMount();
    }

    onSubmit() {
        this.onChangeModeHandler(false);
    }

    render() {
        let context = null;
        let context_bottom = '';
        if (this.state.edit_mode) {
            if (this.state.fields_description.attributes !== undefined) {
                context_bottom = <div className='rc-form-buttons'>
                    <BtnCancel onClickHandler={this.onCancel}>{this.props.cancel_button_text}</BtnCancel>
                    <BtnPrimary onClickHandler={this.onSubmit}>{this.props.submit_button_text}</BtnPrimary>
                </div>
            }


            context = <form><DropDownField field_name={this.props.name}
                                     field_hint={this.props.name_hint}
                                     function_name={this.state.function_name}
                                     onChangeFunction={this.onChangeFunctionHandler}
                                          values={this.props.values}/>
                <div className="col-md-12 col-md-offset-1">
                  <FunctionFields attributes={this.state.fields_description.attributes}
                                  attributeHints={this.state.fields_description.attribute_hints}
                                  attributeValues={this.state.fields_description.attribute_values}
                                  attributeOrders={this.state.fields_description.attribute_orders}
                                  currentAttributeValues={this.state.function_attributes}
                                  edit_mode={this.state.edit_mode}/>
                </div>
                {context_bottom}
            </form>


        } else {
            context = <div>
                <div className="rc-block-visible-data">{this.state.function_name}</div>
                <div className="col-md-12 col-md-offset-1">
                  <FunctionFields attributes={this.state.fields_description.attributes}
                                  attributeHints={this.state.fields_description.attribute_hints}
                                  currentAttributeValues={this.state.function_attributes}/>
                </div>
            </div>
        }

        return (
            <React.Fragment>
                <div className="rc-block-item" id={`${this.props.resource_class}_` + this.props.name}>
                    <div className="rc-block-content" >
                        <FieldTitle name={this.props.name_title}
                                    onChangeMode={this.onChangeModeHandler}
                                    read_only={false}
                                    spinner={this.state.spinner} />
                        {context}
                    </div>
                </div>
            </React.Fragment>
        );    }

}

FunctionEditor.propTypes = {
    name: PropTypes.string,
    name_title: PropTypes.string,
    name_hint: PropTypes.string,
    resource_class: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    values: PropTypes.string,
    start_value: PropTypes.string,
    start_value_attributes: PropTypes.string,
    read_only: PropTypes.bool,
    url_for_read_parameters: PropTypes.string,
    url_for_write_parameters: PropTypes.string
};

export default FunctionEditor