const api_url = "https://7dsl39y93b.execute-api.us-east-1.amazonaws.com/prod/visitors";
const countEl = document.getElementById("count");

// function to create a random value for the cookie
function generateVisitorId() {
  return '_' + Math.random().toString(36).substring(2, 11);
}

// function to create a cookie
function setCookie(name, value, days) {
  // declare d to create the expiry date
  const d = new Date();
  d.setTime(d.getTime() + (days*24*60*60*1000));
  // cookie syntax 'UID=Value; expires=blahblah; path=/'
  document.cookie = `${name}=${value}; expires=${d.toUTCString()}; path=/`;
}

// check if the user has a cookie or not
function getCookie(name) {
  // split 'UID=sdflkj; expires=blahblah; path=/' based on '; '
  const cookies = document.cookie.split('; ');
  for (const cookie of cookies) {
    // k= VID v=sdflkj
    const [k, v] = cookie.split('=');
    // return sdflkj
    if (k === name) return v;
  }
  return '';
}

// get the visitor count from the DB
async function fetchVisitorCount() {
  // Make a GET request to the getVisi.. api
  const res = await fetch(api_url);
  // if connection not 200 throw and error
  if (!res.ok) throw new Error('Failed to fetch count');
  // else store the response in a var called data
  const data = await res.json();
  // in both cases return data or 0
  return data.Visitor_Count || 0;
}

// update the visitor count
async function updateVisitorCount() {
  // Make a GET request to the getVisi.. api
  const res = await fetch(api_url, { method: 'POST' });
  // if connection not 200 throw and error
  if (!res.ok) throw new Error('Failed to update count');
  const data = await res.json();
  // in both cases return data or 0
  return data.Visitor_Count || 0;
}


async function handleVisitor() {
  try {
    const vid = getCookie("VID");
    let count;
    // if there is a cookie
    if (vid) {
      count = await fetchVisitorCount();
    } else {
      // if there is no cookie generate a random value, and set it
      const newVid = generateVisitorId();
      setCookie("VID", newVid, 30);
      count = await updateVisitorCount();
    }
    countEl.textContent = count;
  } catch (err) {
    console.error("Error handling visitor:", err);
  }
}

handleVisitor();


















