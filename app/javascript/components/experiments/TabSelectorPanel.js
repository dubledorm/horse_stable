import React from "react"
import PropTypes from "prop-types"
import {TestTask} from "./ExperimentFunctions";


class TabSelectorPanel extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            activeTabId: props.activeTabId
        }
        this.onChangeValue = this.onChangeValue.bind(this);
    }


    onChangeValue(tabId, e) {
        e.preventDefault();
        this.setState({activeTabId: tabId});
        // Проходим по всем элементам
        for(let field of this.props.fieldObjects) {
            let element = $('#' + field.tabId).first();
            if (element == null) {
                continue;
            }
            if (field.tabId == tabId) {
                element.removeClass('hidden')
            } else {
                element.addClass('hidden')
            }
        }
    }

    buildRow(field, key) {
        let className = 'btn btn-default';
        let itemName = field.tabName;
        if (this.state.activeTabId == field.tabId) {
            className = className + ' active'
        }
        return <li key={key}>
            <a className={className} href={'#'}  onClick={this.onChangeValue.bind(this, field.tabId)}>
                {itemName}
            </a>
        </li>
    }

    render() {
        let context = [];
        let index = 1;

        for(let field of this.props.fieldObjects) {
           context.push(this.buildRow(field, index));
            index += 1;
        }


        return(
            <React.Fragment>
                <ul className='tab_selector_panel text-center'>
                    {context}
                </ul>
            </React.Fragment>
        )
    }
}

TabSelectorPanel.propTypes = {
    fieldObjects: PropTypes.array,
    activeTabId: PropTypes.string
};

export default TabSelectorPanel