begin;
\ir helpers.psql
select plan(11);

update public.profiles set is_verified = false where id in (tests.uid(7), tests.uid(9));

-- Sending -------------------------------------------------------------------

select tests.login(7);
select throws_ok(
  $$ select public.submit_verification('thumbs_up', tests.uid(8) || '/x.jpg') $$,
  '42501', null,
  'the selfie must be in the person''s own folder'
);
select lives_ok(
  $$ select public.submit_verification('thumbs_up', tests.uid(7) || '/selfie.jpg') $$,
  'a person sends a selfie with the requested pose'
);
select throws_ok(
  $$ select public.submit_verification('peace_sign', tests.uid(7) || '/again.jpg') $$,
  'P0001', 'A request is already pending',
  'one request at a time'
);
select throws_ok(
  $$ select public.update_verification_hack() $$,
  '42883', null,
  'there is no way to self-verify (no such function)'
);

-- Reviewing -----------------------------------------------------------------

select is(
  (select count(*)::int from public.admin_list_verifications()),
  0,
  'only admins see the queue'
);
select throws_ok(
  $$ select public.admin_review_verification(
       (select id from public.verification_requests where user_id = tests.uid(7)), true) $$,
  '42501', null,
  'only admins review'
);

-- Ana (1) is admin.
select tests.login(1);
select is(
  (select (pose::text, cardinality(photo_paths))::text
   from public.admin_list_verifications() where user_id = tests.uid(7)),
  '(thumbs_up,2)',
  'admins see the pose and the profile photos to compare'
);
select is(
  public.admin_review_verification(
    (select id from public.verification_requests where user_id = tests.uid(7)), true),
  tests.uid(7) || '/selfie.jpg',
  'approving returns the selfie path for deletion'
);
select tests.logout();
select is(
  (select (p.is_verified, v.selfie_path is null)::text
   from public.profiles p join public.verification_requests v on v.user_id = p.id
   where p.id = tests.uid(7)),
  '(t,t)',
  'the profile gets the badge and the selfie reference is cleared'
);

-- Rejection keeps the badge off and tells why.
select tests.login(9);
select public.submit_verification('point_up', tests.uid(9) || '/s.jpg');
select tests.login(1);
select public.admin_review_verification(
  (select id from public.verification_requests where user_id = tests.uid(9)),
  false, 'O rosto não aparece na selfie.');
select tests.login(9);
select is(
  (select (status::text, rejection_reason)::text from public.verification_requests
   where user_id = tests.uid(9)),
  '(rejected,"O rosto não aparece na selfie.")',
  'a rejected person sees the reason'
);

select tests.login(7);
select throws_ok(
  $$ select public.submit_verification('point_up', tests.uid(7) || '/n.jpg') $$,
  'P0001', 'Already verified',
  'verified people do not send again'
);

select * from finish();
rollback;
