import React from "react"
import PropTypes from "prop-types"
import BtnCancel from "./BtnCancel"
import BtnPrimary from "./BtnPrimary"

function OptionItem(props) {
    return (
        <option value={props.value}>{props.name}</option>
    )
}


class EditForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {local_value: this.props.start_value, error_message: ''};

        // this.onlocalChangeValue = this.onlocalChangeValue.bind(this);
        this.onSubmit = this.onSubmit.bind(this);
        this.onSubmitSuccess = this.onSubmitSuccess.bind(this);
        this.onSubmitError = this.onSubmitError.bind(this);
        this.onCancel = this.onCancel.bind(this);

        this.input = React.createRef();
    }

    onSubmit(){
        this.props.onToggleSpinner(true);
        $.ajax({
            type: "PUT",
            url: this.props.url,
            dataType: "json",
            data: { [this.props.resource_class]: { [this.props.field_name]: this.input.current.value }},
            success: this.onSubmitSuccess,
            error: this.onSubmitError
        });
    }

    onSubmitSuccess(){
        this.setState({ error_message: '' });
        this.props.onChangeValue(this.input.current.value);
        this.props.onChangeMode(false);
        this.props.onToggleSpinner(false);
    }

    onSubmitError(error){
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({ error_message: error_message });
        this.props.onToggleSpinner(false);
    }

    onCancel(){
        this.props.onChangeMode(false);
    }

    // onlocalChangeValue(event){
    //     this.setState({local_value: event.target.value});
    // }

    componentDidMount() {
        this.input.current.focus();
    }



    createEditElement() {
       let element_type = this.props.edit_element_type;
       let field_name = this.props.resource_class +'['+this.props.field_name+']';
       let listOptions = '';

       if (this.props.values != null) {
           listOptions = JSON.parse(this.props.values).map((item) => <OptionItem key={item[1]} value={item[1]} name={item[0]} selected={this.props.start_value}/>);
       }

       let inputComponentTypes = {
            'string': <input type="text" name={field_name} className="form-control" defaultValue={this.props.start_value} ref={this.input} />,
            'text': <textarea name={field_name} className="form-control" defaultValue={this.props.start_value} ref={this.input} />,
            'number': <input type="number" name={field_name} className="form-control" defaultValue={this.props.start_value} ref={this.input} />,
            'drop_down_list': <select name={field_name} className="form-control" defaultValue={this.props.start_value} ref={this.input}>
                {listOptions}
            </select>
       };

       let result = inputComponentTypes[element_type];

       if (result === undefined) {
           console.error(`Unknown element_type. The value ${element_type} is unknown.`);
       }

       return result;
    }

    render() {
        let error_message = '';
        if (this.state.error_message) {
            error_message = <div className="rc-field-error">{this.state.error_message}</div>
        }

        return (
            <div className="rc-block-hidden-form">
                <form onSubmit={this.onSubmit} >
                    <div className="form-group required">
                        {this.createEditElement()}
                        {error_message}
                        <div className="rc-field-hint">{this.props.field_hint}</div>
                    </div>
                    <div className='rc-form-buttons'>
                      <BtnCancel onClickHandler={this.onCancel}>{this.props.cancel_button_text}</BtnCancel>
                      <BtnPrimary onClickHandler={this.onSubmit}>{this.props.submit_button_text}</BtnPrimary>
                    </div>
                </form>
            </div>);
    }
}

EditForm.propTypes = {
    start_value: PropTypes.string,
    field_name: PropTypes.string,
    field_hint: PropTypes.string,
    resource_class: PropTypes.string,
    url: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    onChangeValue: PropTypes.func,
    onChangeMode: PropTypes.func,
    onToggleSpinner: PropTypes.func,
    edit_element_type: PropTypes.string,
    values: PropTypes.string
};

export default EditForm