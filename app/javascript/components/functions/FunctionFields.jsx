import React from "react"
import PropTypes from "prop-types"
import FunctionField from "./FunctionField";

class FunctionFields extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        let fields_arr = [];
        for(let code in this.props.attributes) { fields_arr.push(code) }
        return fields_arr.map(field => <FunctionField key={field}
                                                      fieldName={field}
                                                      fieldTitle={this.props.attributes[field]}
                                                      fieldValues={this.props.attributeValues ? this.props.attributeValues[field] : []}
                                                      fieldHint={this.props.attributeHints ? this.props.attributeHints[field] : ''}
                                                      value={this.props.currentAttributeValues ? this.props.currentAttributeValues[field] : ''}
                                                                edit_mode={this.props.edit_mode}
                                                      onChangeAttribute={this.props.onChangeAttribute}/>);
    }
}

FunctionFields.propTypes = {
    attributes: PropTypes.object,
    attributeValues: PropTypes.object,
    attributeOrders: PropTypes.array,
    attributeHints: PropTypes.object,
    currentAttributeValues: PropTypes.object,
    onChangeAttribute: PropTypes.func,
    edit_mode: PropTypes.bool
};

export default FunctionFields