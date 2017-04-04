(function(){
    angular.module('BB.Directives').directive('bbAccessibleGrid', ()=>{
    return {
        restrict: 'A',
        link: (scope, element)=>{
            let navigator;
            /* Activate on element focus event */
            element.bind('focus', ()=>{
                    navigator = navigator? navigator: new GridNavigator(scope, element);
                    navigator.cells = element.find('tr td div h4').parent();
                    navigator.columns = element.find('tr td');
                    navigator.focus();
            });

        }
    }
});

/** grid accessibility navigator  */
class GridNavigator{

    /**
     *
     * @param {*} scope
     * @param {*} elem <table element bound
     */
    constructor (scope, elem){
        this.scope = scope;
        this.elem = elem;
        this.cells;
        this.columns;
        this.activeCellIndex = 0;
        this.event;
        this.activeKeyCode;
        this.activeCell;
        this.accordion; //accordion in active cell
        this.accordionSlots;
        this.accordionSlotIndex = 0;
        this.inAccordion = false;
        this.prevCell;
        this.listen();
    }

    /**
     * Listen for nav keys to delegate to main grid or cell-accordion navgation
     *  */
    listen(){
        this.elem.on('keydown', (e)=>{
            this.event = e;
            this.activeKeyCode = e.keyCode;
            this.prevCell = this.cells.eq(this.activeCellIndex); //set the prevCell to this one so we can swap tabindex with next one

            if(!this.inAccordion) {
                this.gridNav();
            } else{
                this.accordionNav();
            }
            e.preventDefault();
            e.stopPropagation();
        });
    }




    //navigating main grid
    gridNav(){
        let columns = this.columns.length; //the first and last are arrow <
        let endCellIndex = (columns * 3) - 1; //getting the first last cell on the right
        switch(this.activeKeyCode){

            case 39: //move right
                this.activeCellIndex += 3;
                this.activeCellIndex = this.activeCellIndex > endCellIndex ? this.activeCellIndex - 3: this.activeCellIndex;
                this.focus();
                break;
            case 37: //move left
                this.activeCellIndex -= 3;
                this.activeCellIndex = this.activeCellIndex < 0 ? this.activeCellIndex + 3 :this.activeCellIndex;
                this.focus();
                break;
            case 40: //down, focus accordions in cell
                this.activeCellIndex += 1;
                this.activeCellIndex = this.activeCellIndex > this.cells.length ? this.activeCellIndex - 1 : this.activeCellIndex;
                this.focus();
                break;
            case 38 : //up
                this.activeCellIndex -= 1;
                this.activeCellIndex = this.activeCellIndex < 0 ? this.activeCellIndex + 1 : this.activeCellIndex;
                this.focus();
                break;
            case 9: //tab,ecs
            case 27:
                this.escape();
                break;
            case 13:
            case 32:
                this.accordionFocus();
                break;
        }
    }
    /**
     * Naviagtion in accordion mode **/
    accordionNav(){

        switch(this.activeKeyCode) {

            case 38: //up, focus accordions in cell
                this.accordionSlotIndex -= 1;
                this.accordionSlotIndex = (this.accordionSlotIndex < 0)?this.accordionSlots.length-1:this.accordionSlotIndex;
                this.accordionFocus();
                break;
            case 40 : //down
                this.accordionSlotIndex += 1;
                this.accordionSlotIndex = (this.accordionSlotIndex >= this.accordionSlots.length)?0:this.accordionSlotIndex;
                this.accordionFocus();
                break;
            case 27: //esc
                this.accordionBlur();
            break;
            case 9: //tab
                //shift+tab || shift+esc
                if(this.event.shiftKey){
                    this.accordionBlur();
                }
                break;
            case 13:
            case 32:
                if(this.inAccordion){
                    this.accordionSlots.eq(this.accordionSlotIndex).click();
                    this.accordion.click();
                    this.accordionBlur();
                }
                break;
        }

    }

    /** Focus on selected grid cells */
    focus(){
        this.activeCell = this.cells.eq(this.activeCellIndex);
        if(this.prevCell){
            this.prevCell.attr('tabindex', '-1');
        }
        this.activeCell.attr('tabindex', '0').focus();

    }


    /** Focus on cell-accordion selection */
    accordionFocus(){
        this.accordion = this.activeCell.find('h4>div');
        if(!this.inAccordion && !this.event.shiftKey){
            this.activeCell = this.cells.eq(this.activeCellIndex);
            this.activeCell.attr('tabindex', '-1');
            this.activeCell.blur();
            this.inAccordion = true;
            this.accordion.click();
        }
        this.accordionSlots = this.cells.eq(this.activeCellIndex).parent().parent().find('#time-slots li');
        this.accordionSlots.eq(this.accordionSlotIndex).attr('tabindex', '0').focus();

    }

    /** escape accordion navigation to grid */
    accordionBlur(){
        let activeSlot = this.accordionSlots.eq(this.accordionSlotIndex);
            activeSlot.attr('tabindex', '-1').blur();
        this.activeCell.attr('tabindex', '0');
        this.accordion.click();
        this.inAccordion = false;
        this.accordionSlotIndex = 0;
        this.focus();
    }
    /** Lose the focus on grid*/
    escape(){
        this.activeCell.attr('tabindex', '-1');
        this.activeCell.blur();
        //this.elem.attr('tabindex','1');
        if(this.event.shiftKey){
            let prev = this.elem.parent().prev().find('button');
            if(prev.attr('disabled')){
                prev = $('.month-header h2');
            }
            prev.focus();

        }
        else
            this.elem.parent().next().find('button').focus();
    }
}

})();

