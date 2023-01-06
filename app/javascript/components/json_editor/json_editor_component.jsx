import React from "react"
import PropTypes from "prop-types"
import JSONEditor from 'jsoneditor';

import '../../styles/json_editor_component.scss'

class JsonEditorComponent extends React.Component {
    constructor(props) {
        super(props);
        this.onChange = this.onChange.bind(this);
    }

    onChange(KeyValueStr) {
        try {
            let resultJson = JSON.parse(KeyValueStr);
            this.props.onChange(JSON.stringify(resultJson));
        } catch(e) {

        }
    }

    componentDidMount () {
        const options = {
            mode: this.props.mode || 'code',
            onChangeText: this.onChange,
            language: 'ru'
        };

        this.jsoneditor = new JSONEditor(this.container, options);
        this.jsoneditor.set(this.props.json);
    }

    componentWillUnmount () {
        if (this.jsoneditor) {
            this.jsoneditor.destroy();
        }
    }

    render() {
        return (
            <div className="jsoneditor-react-container" ref={elem => this.container = elem} />
        );
    }
}

JsonEditorComponent.propTypes = {
    json: PropTypes.object,
    onChange: PropTypes.func,
    mode: PropTypes.string
};

export default JsonEditorComponent