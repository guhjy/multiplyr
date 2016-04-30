context("summarise")

test_that ("summarise() works on ungrouped data", {
    dat <- fastdf (x=1:100, y=rep(2, 100), alloc=1, cl=2)
    dat <- dat %>% summarise (x=length(x), y=length(y)/2, z=sum(y))
    expect_equal (dat$x, 100)
    expect_equal (dat$y, 50)
    expect_equal (dat$z, 200)
    stopCluster (attr(dat, "cl"))
    rm (dat)
})

test_that ("summarise() works on grouped data", {
    dat <- fastdf (x=1:100, y=rep(2, 100),
                   G=rep(c("A", "B", "C", "D"), each=25),
                   alloc=1, cl=2)
    dat <- dat %>% partition_group (G)
    dat <- dat %>% summarise (x=length(x), y=length(y)/2, z=sum(y))
    expect_equal (dat$x, rep(25, 4))
    expect_equal (dat$y, rep(12.5, 4))
    expect_equal (dat$z, rep(50, 4))
    stopCluster (attr(dat, "cl"))
    rm (dat)
})

test_that ("summarise() works with transmute/rename", {
    dat <- fastdf (x=1:100, y=rep(2, 100),
                   G=rep(c("A", "B", "C", "D"), each=25),
                   alloc=1, cl=2)
    dat <- dat %>% partition_group(G)
    dat <- dat %>%
        rename(a=x, b=y) %>%
        transmute(b = b*2) %>%
        summarise(x=length(b), y=sum(b))

    expect_equal (dat$x, rep(25, 4))
    expect_equal (dat$y, rep(100, 4))

    stopCluster (attr(dat, "cl"))
    rm (dat)
})