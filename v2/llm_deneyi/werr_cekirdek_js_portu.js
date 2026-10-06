// ---- WERR kernel port (werr/fractal.py + gates/base.py tripod branch), checked against Python and R ----
function vecErf(x){const s=Math.sign(x),a=Math.abs(x),t=1/(1+0.3275911*a);const p=((((1.061405429*t-1.453152027)*t+1.421413741)*t-0.284496736)*t+0.254829592)*t;return s*(1-p*Math.exp(-a*a))}
const ncdf=z=>0.5*(1+vecErf(z/Math.SQRT2));
const WC=[],UU=[];for(let k=0;k<=36;k++){const u=k/36;UU.push(u);let om=ncdf(u/0.12)+ncdf((1-u)/0.12)-1;om=Math.min(Math.max(om,0.45),1);WC.push(1/om)}
function werrTripod(cx,cy,zoom){const R=36,M=36,zf=[0.6,1.0,1.6],wz=[0.25,0.5,0.25],out=[0,0,0,0];
  for(let s=0;s<3;s++){const sc=1/(zoom*zf[s]),sw=[0,0,0,0],scn=[0,0,0,0],su=[0,0,0,0];
    for(let j=0;j<R;j++){const ci=cy-sc+2*sc*j/(R-1);for(let k=0;k<R;k++){const cr=cx-sc+2*sc*k/(R-1);let zr=0,zi=0,e=M;
      for(let i=0;i<M;i++){const t=zr*zr-zi*zi+cr;zi=2*zr*zi+ci;zr=t;if(Math.sqrt(zr*zr+zi*zi)>2){e=i;break}}
      const q=(j<18?0:2)+(k<18?0:1);sw[q]+=WC[e];su[q]+=WC[e]*UU[e];if(UU[e]>=0.90)scn[q]+=WC[e]}}
    for(let q=0;q<4;q++)out[q]+=wz[s]*(0.65*scn[q]/sw[q]+0.35*su[q]/sw[q])}
  return out}
const GATE_SEED=[-0.80792578443908969,0.18302136198124994,300], TWIN_W=[0.031895461427411224,1.067104626736044,3,-3];
const agree=(a,b)=>(a===null||b===null)?0:(a===b?1:-1);
function gateGain(st,mode){const h=st.hist,a1=agree(h[0],h[1]),a2=agree(h[1],h[2]),a3=agree(h[2],h[3]),m=2*Math.abs(st.rho)/3-1,risk=Math.abs(st.rho)-1;
  let w;if(mode==="twin")w=TWIN_W;else{const sc=1/GATE_SEED[2],dx=Math.tanh(risk!==0?risk:(a1+m)/2)*sc*0.45,dy=Math.tanh((a2+a3)/2)*sc*0.45;
    w=werrTripod(GATE_SEED[0]+dx,GATE_SEED[1]+dy,GATE_SEED[2]*(1+0.1*Math.sin(a1+a2+m+a3))).map(q=>(q-0.5)*6)}
  const z=Math.max(-50,Math.min(50,w[0]*a1+w[1]*a2+w[2]*m+w[3]));return 1/(1+Math.exp(-z))}
const makeGate=mode=>({init:()=>({b:0,hist:[null,null,null,null],rho:0}),b:s=>s.b,update:(s,x)=>{s.hist=[x,s.hist[0],s.hist[1],s.hist[2]];s.rho=(1-1/3)*s.rho+(2*x-1);
  s.b+=(0.05+0.55*gateGain(s,mode))*(2*x-1);return s}});
// original PFP-Core (WerreduR): c <- c +/- 0.05 - 0.44 (c - X), b = 10 (c - X); only the real part matters
const makePFPCore=()=>({init:()=>({d:0}),b:s=>10*s.d,update:(s,x)=>{s.d=s.d+(x?0.05:-0.05)-0.44*s.d;return s}});
