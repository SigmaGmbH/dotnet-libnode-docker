exports.foo = (bar)=> {

    console.log('This is a foo method');
    console.log("typeof bar == ", typeof bar);
    if((typeof bar)!=='undefined'){
        console.log("bar == ", bar);
    }

    return "return from foo "+bar;
}


exports.afoo = async (bar) =>
{
    console.log('This is an async foo method');
    this.foo(bar);

    console.log("Before sleep");
    await sleep(2000);
    console.log("After sleep");
    return "return from afoo "+bar;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
