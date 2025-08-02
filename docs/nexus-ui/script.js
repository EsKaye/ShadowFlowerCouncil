async function loadProfiles() {
  const container = document.getElementById('members');
  const listResp = await fetch('../../profiles');
  const text = await listResp.text();
  const files = text.match(/href="(.*?)"/g).map(m => m.slice(6, -1)).filter(f => f.endsWith('.yaml'));
  for (const file of files) {
    const res = await fetch('../../profiles/' + file);
    const yamlText = await res.text();
    const data = jsyaml.load(yamlText);
    const div = document.createElement('div');
    div.className = 'member';
    div.innerHTML = `<strong>${data.name}</strong> - gift: ${data.gift}, wound: ${data.wound}`;
    container.appendChild(div);
  }
}

document.addEventListener('DOMContentLoaded', loadProfiles);
