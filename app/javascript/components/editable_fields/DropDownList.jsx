import React from "react"
import PropTypes from "prop-types"
import FieldTitle from "./FieldTitle";
import EditForm from "./EditForm";

class DropDownList extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeModeHandler = this.onChangeModeHandler.bind(this);
        this.onChangeValueHandler = this.onChangeValueHandler.bind(this);
        this.onToggleSpinner = this.onToggleSpinner.bind(this);
        this.state = {value: props.start_value,
            spinner: false,
            name_title: props.name_title,
            edit_mode: false,
            read_only: 'read_only' in props ? props.read_only : false
        }
    }

    onChangeValueHandler(value) {
        this.setState({value: value});
    }

    onChangeModeHandler(edit_mode) {
        this.setState({edit_mode: edit_mode});
    }

    onToggleSpinner(mode) {
        this.setState({spinner: mode});
    }

    render() {
        let context = null;
        if (this.state.edit_mode) {
            context = <EditForm submit_button_text={this.props.submit_button_text}
                                cancel_button_text={this.props.cancel_button_text}
                                field_name={this.props.name}
                                field_hint={this.props.name_hint}
                                resource_class={this.props.resource_class}
                                start_value={this.state.value}
                                url={this.props.url}
                                onChangeValue={this.onChangeValueHandler}
                                onChangeMode={this.onChangeModeHandler}
                                onToggleSpinner={this.onToggleSpinner}
                                edit_element_type={'drop_down_list'}
                                values={this.props.values}/>;


        } else {
            context = <div className="rc-block-visible-data">{this.state.value}</div>
        }

        return (
            <React.Fragment>
                <div className="rc-block-item" id={`${this.props.resource_class}_` + this.props.name}>
                    <div className="rc-block-content" >
                        <FieldTitle name={this.state.name_title}
                                    onChangeMode={this.onChangeModeHandler}
                                    read_only={false}
                                    spinner={false} />
                        {context}
                    </div>
                </div>
            </React.Fragment>
        );
    }

}

DropDownList.propTypes = {
    name: PropTypes.string,
    name_title: PropTypes.string,
    name_hint: PropTypes.string,
    resource_class: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    values: PropTypes.string,
    start_value: PropTypes.string,
    read_only: PropTypes.bool
};

export default DropDownList