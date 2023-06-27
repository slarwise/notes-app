// Note: { title: string, text: string }

const Koa = require('koa');
const Router = require('@koa/router');
const { bodyParser } = require('@koa/bodyparser');
const { createClient } = require('redis');

async function startApp() {

  const redis = createClient();
  redis.on("error", err => console.log("Redis Client Error", err));
  await redis.connect();

  const app = new Koa();
  const router = new Router();

  router.get('/notes', async ctx => {
    const titles = await redis.keys("*");
    let notes = [];
    for (let title of titles) {
      const text = await redis.get(title);
      notes.push({ title, text });
    }
    const textQuery = ctx.request.query.text;
    if (textQuery) {
      notes = notes.filter(n => n.text.includes(textQuery));
    }

    ctx.body = notes;
    console.log(`  ${notes.length} notes`);
  });

  router.post('/notes', async ctx => {
    const { title, text } = ctx.request.body;
    await redis.set(title, text);
    ctx.status = 200;
    console.log(`  title: ${title}`);
  });

  router.get('/notes/:title', async ctx => {
    const title = ctx.params.title;
    const text = await redis.get(title);
    ctx.body = { title, text };
    console.log(`  title: ${title}`);
  });

  async function logger(ctx, next) {
    if (ctx.request.querystring) {
      console.log(`${ctx.method} ${ctx.path}?${ctx.querystring}`);
    } else {
      console.log(`${ctx.method} ${ctx.path}`);
    }
    await next();
  }

  app
    .use(logger)
    .use(bodyParser())
    .use(router.routes())

  const port = 3000;
  app.listen(port, () => {
    console.log(`App listening on port ${port}`);
  });
}

startApp();
