async function askAI(topic, question){
    const box=document.getElementById("aiAnswer");
    box.textContent="Thinking...";
    try{
        const res=await fetch("/Ai/Ask",{
            method:"POST",
            headers:{"Content-Type":"application/json"},
            body:JSON.stringify({topic:topic,question:question})
        });
        const data=await res.json();
        box.textContent=data.answer || "No response.";
    }catch(e){ box.textContent="Could not load the tutor hint."; }
}
