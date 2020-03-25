import { LightningElement, track, wire } from 'lwc';
import finalCacheTest from '@salesforce/apex/CacheExecution.finalCacheTest';

export default class CacheDemo extends LightningElement {
    results;
    displayContent = false;
    displayError = false;
    isLoading = false;

   
    handleClick(e) {
        console.log('in handle click');
        this.isLoading = true;
       finalCacheTest()
        .then(result => {
            console.log('result $$ ' + JSON.stringify(result));
            this.results = result;
            this.displayContent = true;
            this.displayError = false;
            this.isLoading = false;
        })
        .catch (error => {
            console.log('erorr ' + JSON.stringify(error));
            this.displayContent = false;
            this.displayError = true;
            this.isLoading = false;
        });
    

    }

    handleClearClick(e) {
        this.results = [];
        this.displayContent = false;
    }

    get details() {
        return JSON.stringify(this.results.details).substr(1,1000) + '...';
    }

}