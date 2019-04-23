use "ponytest"
use ".."
use "collections"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_TestLRUCacheInsertion)
    test(_TestLRUCacheRemoval)
    test(_TestLRUCacheSize1)
    test(_TestLRUCacheSize0)

class iso _TestLRUCacheInsertion is UnitTest
  fun name(): String => "Testing LRU Insertion"
  fun apply(t: TestHelper) =>
    let size: USize = 5
    let overage: USize = 3
    let cache = LRUCache[USize, USize](size, t)
    for i in Range(0, size + overage) do
      cache(i) = i
    end
    for i in Range(0, overage) do
      match cache(i)
        | None => continue
        | let value: USize =>
          t.fail(i.string() + "is not None but " + value.string())
      end
    end
    for i in Range(overage, size + overage) do
      match cache(i)
        | None => t.fail(i.string() + "Value is None")
        | let value: USize => t.assert_true(value == i)
      end
    end

class iso _TestLRUCacheRemoval is UnitTest
  fun name(): String => "Testing LRU Removal"
  fun apply(t: TestHelper) =>
    let size: USize = 5
    let cache = LRUCache[USize, USize](size, t)
    for i in Range(0, size) do
      cache(i) = i
    end
    for i in Range(0, size) do
      t.assert_true(cache.contains(i))
    end
    for i in Range(0, size) do
      cache.remove(i)
    end
    for i in Range(0, size) do
      t.assert_false(cache.contains(i))
    end

class iso _TestLRUCacheSize1 is UnitTest
  fun name(): String => "Testing LRU Insertion with Size of 1"
  fun apply(t: TestHelper) =>
    let size: USize = 1
    let overage: USize = 3
    let cache = LRUCache[USize, USize](size, t)
    for i in Range(0, size + overage) do
      cache(i) = i
    end
    for i in Range(0, overage) do
      match cache(i)
        | None => continue
        | let value: USize =>
          t.fail(i.string() + "is not None but " + value.string())
      end
    end
    for i in Range(overage, size + overage) do
      match cache(i)
        | None => t.fail(i.string() + "Value is None")
        | let value: USize => t.assert_true(value == i)
      end
    end
class iso _TestLRUCacheSize0 is UnitTest
  fun name(): String => "Testing LRU Insertion with Size of 0"
  fun apply(t: TestHelper) =>
    let size: USize = 0
    let overage: USize = 3
    let cache = LRUCache[USize, USize](size, t)
    for i in Range(0, size + overage) do
      cache(i) = i
    end
    for i in Range(0, overage) do
      match cache(i)
        | None => continue
        | let value: USize =>
          t.fail(i.string() + "is not None but " + value.string())
      end
    end
