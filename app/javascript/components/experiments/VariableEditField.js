import React from "react"
import PropTypes from "prop-types"

class VariablesEditField extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
                    <div className="inline-form-group">
                        <input type="text" name={this.props.base_field_name + '_name'} className="form-control field-name" defaultValue={this.props.variable_name} />
                        <input type="text" name={this.props.field_name + '_value'} className="form-control field-value" defaultValue={this.props.variable_value} />
                        <div><div className='rc-spinner'><i className='fa fa-trash rc-fa-trash' onClick={this.props.on_delete.bind(this, this.props.base_field_name)} /></div></div>
                    </div>
        )
    }
}

VariablesEditField.propTypes = {
    base_field_name: PropTypes.string,
    variable_name: PropTypes.string,
    variable_value: PropTypes.string,
    on_delete: PropTypes.func
};

export default VariablesEditField