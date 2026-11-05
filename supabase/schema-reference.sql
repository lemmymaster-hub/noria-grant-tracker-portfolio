-- Public collaborative tracker. Only this dedicated project's table is writable anonymously.
create table public.noria_grants (
  id text primary key check (id ~ '^[A-Za-z0-9_-]{1,80}$'),
  payload jsonb not null,
  revision bigint not null default 1 check (revision > 0),
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  constraint valid_grant_payload check (
    jsonb_typeof(payload) = 'object'
    and payload->>'id' = id
    and length(payload::text) <= 20000
    and length(payload->>'name') between 1 and 200
    and length(payload->>'topic') <= 500
    and length(payload->>'funding') <= 1000
    and length(payload->>'assessment') <= 2000
    and length(payload->>'notes') <= 4000
    and length(payload->>'url') <= 2000
    and (payload->>'url' = '' or payload->>'url' ~ '^https?://')
    and (payload->>'deadline' = '' or payload->>'deadline' ~ '^\d{4}-\d{2}-\d{2}$')
    and payload->>'status' in ('', 'applied', 'prep', 'no')
    and (payload->>'priority')::int between 1 and 4
    and jsonb_typeof(payload->'fit') = 'object'
    and (payload->'fit'->>'noria')::int between 0 and 100
    and (payload->'fit'->>'bsl')::int between 0 and 100
    and (payload->'fit'->>'nrn')::int between 0 and 100
  )
);

create function public.noria_grants_bump_revision()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  new.revision := old.revision + 1;
  new.updated_at := now();
  return new;
end;
$$;
create trigger noria_grants_revision before update on public.noria_grants
  for each row execute function public.noria_grants_bump_revision();
revoke all on function public.noria_grants_bump_revision() from public;

alter table public.noria_grants enable row level security;
revoke all on public.noria_grants from public, anon, authenticated;
grant select on public.noria_grants to anon, authenticated;
grant insert (id, payload) on public.noria_grants to anon, authenticated;
grant update (payload, deleted) on public.noria_grants to anon, authenticated;
create policy "Anyone can read grants" on public.noria_grants for select to anon, authenticated using (true);
create policy "Anyone can add grants" on public.noria_grants for insert to anon, authenticated with check (true);
create policy "Anyone can edit grants" on public.noria_grants for update to anon, authenticated using (true) with check (true);

-- Rows are soft deleted so the scheduled seed import does not resurrect them.

