----------------------------------------
--Powered By Artorias
--2020.7.6
----------------------------------------

--Convex Hull凸包算法

function GetConvexHull(points)
    --传入点集{{},{},{},....}
    if type(points) ~= 'table' then
        return nil
    end

    local p=1

    --指定两点取向量 a为起点 b为终点
    ---@param a table
    ---@param b table
    local function GetHypot(a,b)
        return {b[1]-a[1],b[2]-a[2]}
    end

    --指定两个矢量求矢量积
    local function CrossProduct(a,b)
        local moda,modb=math.sqrt(a[1]^2+a[2]^2),math.sqrt(b[1]^2+b[2]^2)
        local hynum=a[1]*b[1]+a[2]*b[2]
        local sintetha=math.sqrt(1-((hynum/(moda/modb))^2))
        return moda*modb*sintetha
    end

    --取出点集中纵坐标最小的点
    for i=2,#points do
        if points[i][2] < points[p][2] then
            p=i
        elseif points[i][2]==points[p][2] then
            if points[p][1]>points[i][1] then
                p=i
            end
        end
    end
    --构建矢量集
    local function sortGT(a, b)
        return a[1] > b[1]
    end
    local vectors={}
    for i=1,#points do
        local basepoint=points[p]
        if i ~= p then
            local dethax,dethay=points[i][1]-basepoint[1],points[i][2]-basepoint[2]
            local hypot=math.sqrt(dethax^2+dethay^2)
            local cos=(dethax^2+hypot^2-dethay^2)/(2*dethax*hypot)
            table.insert(vectors,{cos,i})
        end
    end
    table.sort(vectors,sortGT)
    --构建按余弦值从小到大排序的点集，需要序号时取points[vectors[i][2]],现在确定55行以上的代码是正确的
    local pointsID={}
    --这个表存放最后凸包的点的序号
    table.insert(pointsID,p)
    local n=1
    --下方排序的flag
    for i,v in pairs(vectors) do
        if n==1 then
            table.insert(pointsID,points[vectors[n][2]])
        elseif n == #vectors then
            table.insert(pointsID,points[vectors[#vectors][2]])
        else
            local n1=n-1
            local n2=n+1
            --上一点与下一点的flag
            if CrossProduct(GetHypot(points[vectors[n2][2]],points[vectors[n][2]]),GetHypot((points[vectors[n1][2]]),points[vectors[n][2]])) > 0 then
                table.insert(pointsID,points[vectors[n][2]])
            else
                local flag=n
                local delID={}
                repeat
                    flag=flag-1
                    table.insert(delID,flag)
                until CrossProduct(GetHypot(points[vectors[flag-1][2]],points[vectors[flag][2]]),GetHypot((points[vectors[flag+1][2]]),points[vectors[flag][2]]))>0
                for k,a in pairs(delID) do
                    pointsID[k]=nil
                end
            end
        end
        n=n+1
    end

    return pointsID
end
point={{0,0},{4,3},{6,2},{2,3},{7,5},{1,5},{5,1},{8,6}}
ID=(GetConvexHull(point))
for i,v in pairs(ID) do
    print(point[v][1],point[v][2])
end