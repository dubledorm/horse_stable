import React from "react";

export function TwoStringWrap(props) {
    return <React.Fragment><h3>
        {props.title + ':'}
    </h3>
        {props.children}
    </React.Fragment>
}

export function OneStringWrap(props) {
    return <div className={'row'}>
        <div className={'col-xs-6 col-md-6'}>
            {props.title + ':'}
        </div>
        {props.children}
    </div>
}

export function OneStringValue(props) {
    return  <OneStringWrap title={props.title}>
        <div className={'col-xs-6 col-md-6'}>
            {props.value}
        </div>
    </OneStringWrap>
}

export function TestTaskShort(props) {
    return <div className={'row'}>
        <div className={'col-xs-6 col-md-6'}>
             <span className={'right'}>
               {props.id == undefined ? '' : props.id + ':'}
             </span>
        </div>

        <div className={'col-xs-6 col-md-6'}>
            {props.start_time}
        </div>
    </div>
}

export function TestTask(props) {
    let class_name = 'col-xs-2 col-md-2 success_test_task'

    if (props.test_task.result_kod == 'interrupted') {
        class_name = 'col-xs-2 col-md-2 failed_test_task'
    }


    return <div className={'row'}>
        <div className={'col-xs-2 col-md-2'}>
               {props.test_task.id == undefined ? '' : props.test_task.id + ':'}
        </div>
        <div className={'col-xs-4 col-md-4'}>
            {props.test_task.start_time}
        </div>
        <div className={'col-xs-4 col-md-4'}>
            {props.test_task.state}
        </div>
        <div className={class_name}>
            {props.test_task.translated_result_kod}
        </div>
    </div>
}
